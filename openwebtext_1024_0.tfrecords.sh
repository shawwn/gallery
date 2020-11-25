# tfrecord-json is from https://github.com/shawwn/scrap
tfrecord-json gs://dota-euw4a/datasets/openwebtext-documents/openwebtext_1024_0.tfrecords | head -n 10 | jq . > openwebtext_1024_0.tfrecords-first-10-examples.json
