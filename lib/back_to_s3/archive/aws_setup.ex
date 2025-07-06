defmodule BackToS3.Archive.AWSSetup do
  defstruct [:aws_access_key_id, :aws_secret_access_key]

  import Ecto.Changeset
  alias BackToS3.Repo
  alias BackToS3.Archive
  alias BackToS3.Archive.Setting



  def changeset(aws_setup, attrs) do
    types = %{
      aws_access_key_id: :string,
      aws_secret_access_key: :string
    }

    {aws_setup , types}
    |> cast(attrs, Map.keys(types))
    |> validate_required(Map.keys(types))
  end



  def get() do
    with %{value: aws_setup_encoded} <- Repo.get_by(Setting, group: "setup", key: "AWS_SETUP"),
    {:ok, aws_setup} <- Jason.decode(aws_setup_encoded, keys: :atoms) do
      {:ok, %__MODULE__{aws_access_key_id: aws_setup.aws_access_key_id, aws_secret_access_key: aws_setup.aws_secret_access_key}}
    else
      _ -> {:error, "No S3 setup found"}
    end
  end

  def create(attrs) do
    with %Ecto.Changeset{valid?: true} <- changeset(%__MODULE__{}, attrs),
      {:ok, encoded} <- Jason.encode(attrs),
        {:ok, _settings} <- Archive.create_setting(%{group: "setup", key: "AWS_SETUP", value: encoded}) do
      get()
    else
      %Ecto.Changeset{valid?: false}  = error -> {:error, error}
      error -> error
    end
  end

  def update(aws_setup, attrs) do
    with %Ecto.Changeset{valid?: true} <- changeset(aws_setup, attrs),
    {:ok, encoded} <- Jason.encode(attrs),
      %{value: _aws_setup_encoded} = settings <- Repo.get_by(Setting, group: "setup", key: "AWS_SETUP"),
        {:ok, _settings} <- Archive.update_setting(settings, %{group: "setup", key: "AWS_SETUP", value: encoded}) do
      get()
    else
      %Ecto.Changeset{valid?: false}  = error -> {:error, error}
      error -> error
    end
  end

  def change(%__MODULE__{} = setting, attrs \\ %{}) do
   changeset(setting, attrs)
  end

end
