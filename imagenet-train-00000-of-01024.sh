# the following scripts are in github.com/shawwn/scrap

# convert imagenet tfrecord file into json.
tfrecord-json gs://dota-euw4a/datasets/imagenet/train-00000-of-01024 > imagenet-train-00000-of-01024.json

# upload each training example to a CDN (i.e. convert base64 images into urls).
cat imagenet-train-00000-of-01024.json | jq '{"path": (.path + "?offset=" + (.offset | tostring)), "data": .parsed.features.feature["image/encoded"].bytesList.value[0] }' -c | data-to-url --json | tee -a imagenet-train-00000-of-01024-urls.json

# convert image urls into a gallery.
cat imagenet-train-00000-of-01024-urls.json | natsort | jq .result -r | urls-to-images-dark | tee imagenet-train-00000-of-01024.html
