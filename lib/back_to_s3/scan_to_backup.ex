defmodule BackToS3.ScanToBackup do
  alias BackToS3.Archives.Backup
  alias BackToS3.Archives.File, as: FileRecord


  def scan(backup) do

    DirWalker.stream(backup.path)
    |> Stream.map(fn source ->
      to_trim= Path.dirname(source)
      %{size: size, mtime: {{year, month, day}, {hour, minute, second}}} = File.stat!(source)
      %{
        original_file: source,
        s3_key: Path.join(backup.s3_key_path ++ [String.trim_leading(source, to_trim)]),
        mtime: DateTime.new(year, month, day,hour, minute, second),
        size: size,
        md5: base64(source),
        backup: backup.id
      }
    end)
  end

  def base64(file) do
    hash = :crypto.hash_init(:md5)
    file
    |> File.stream!([], 2048)
    |> Enum.reduce(hash, fn bytes, hash_state ->
      :crypto.hash_update(hash_state, bytes)
    end)
    |> :crypto.hash_final()
    |> Base.encode16()
end

  def test() do
    backup= BackToS3.Archives.get_backup!(1)
    scan(backup)
    |> Stream.take(10)
    |> Enum.map(&IO.inspect/1)
  end
end
