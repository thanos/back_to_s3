CREATE TABLE IF NOT EXISTS "schema_migrations" ("version" INTEGER PRIMARY KEY, "inserted_at" TEXT);
CREATE TABLE sqlite_sequence(name,seq);
CREATE TABLE IF NOT EXISTS "backups" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "label" TEXT, "path" TEXT, "status" TEXT, "s3_bucket" TEXT, "s3_key_path" TEXT, "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL);
CREATE TABLE IF NOT EXISTS "files" ("id" INTEGER PRIMARY KEY AUTOINCREMENT, "original_file" TEXT, "s3_key" TEXT, "s3_bucket" TEXT, "mtime" TEXT, "size" INTEGER, "md5" TEXT, "s3_etag" TEXT, "status" TEXT, "error" TEXT, "job_id" INTEGER, "backup" INTEGER CONSTRAINT "files_backup_fkey" REFERENCES "backups"("id"), "inserted_at" TEXT NOT NULL, "updated_at" TEXT NOT NULL);
CREATE INDEX "files_backup_index" ON "files" ("backup");
INSERT INTO schema_migrations VALUES(20250704175756,'2025-07-04T21:22:45');
INSERT INTO schema_migrations VALUES(20250704181323,'2025-07-04T21:22:45');
