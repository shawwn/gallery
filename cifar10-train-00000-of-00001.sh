# the following scripts are in github.com/shawwn/scrap
set -ex

if [ ! -e 'cifar10-train-00000-of-00001.json' ]
then
  # convert imagenet tfrecord file into json.
  tfrecord-json gs://mldata-euw4/datasets/cifar10/cifar10-train-00000-of-00001 | first 10 | sponge cifar10-train-00000-of-00001.json
fi

if [ ! -e 'cifar10-train-00000-of-00001-urls.json' ]
then
  # upload each training example to a CDN (i.e. convert base64 images into urls).
  cat cifar10-train-00000-of-00001.json | jq '{"path": (.path + "?offset=" + (.offset | tostring)), "data": .parsed.features.feature["image/encoded"].bytesList.value[0] }' -c | data-to-url --json | tee -a cifar10-train-00000-of-00001-urls.json
fi

# convert image urls into a gallery.
cat cifar10-train-00000-of-00001-urls.json | natsort | jq .result -r | urls-to-images-dark | tee cifar10-train-00000-of-00001.html

