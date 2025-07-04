# Back To S3

## Features to be built

1. Deigned to be run as a standalone app locally on your computer.
2. Uses a work queue, `que`, to back up files form any local drive to your `S3` bucket.
3. Once the local file scan is compelte and backup has strated can be interuppteed, puased and stoped. Unless caneled will continue where it left off.
4. Keeps a catalog of all files you've backup in `sqlite3`
3. Only backs up those that are new or have changed.
4. Can notify you on completion, etc.
   

