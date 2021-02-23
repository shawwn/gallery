# the following scripts are in github.com/shawwn/scrap
set -x

# convert imagenet tfrecord file into json.
tfrecord-json gs://mldata-euw4/datasets/imagenet/validation-00000-of-00128 > imagenet-validation-00000-of-00128.json

# upload each training example to a CDN (i.e. convert base64 images into urls).
cat imagenet-validation-00000-of-00128.json | jq '{"path": (.path + "?offset=" + (.offset | tostring)), "data": .parsed.features.feature["image/encoded"].bytesList.value[0] }' -c | data-to-url --json | tee -a imagenet-validation-00000-of-00128-urls.json

# convert image urls into a gallery.
cat imagenet-validation-00000-of-00128-urls.json | natsort | jq .result -r | urls-to-images-dark | tee imagenet-validation-00000-of-00128.html

# grab the first 10 examples.
cat imagenet-validation-00000-of-00128.json | first 10 | jq . | tee imagenet-validation-00000-of-00128-first-10-examples.json
