#!/bin/sh -xe

docker build . --tag hello-container --build-arg "VERSION_NOTE=at not-a-commit-sha"
container_id=$(docker run -d -p 8080:80 --hostname hello-test hello-container)

for i in $(seq 1 5); do
    curl localhost:8080 -o out.txt && break || sleep 2
done

grep -q "^Hostname: hello-test$" out.txt
grep -q "^🐮 Moo! I'm a cow.$" out.txt
grep -q "^cicd-tutorials / animals at not-a-co$" out.txt

docker rm -f ${container_id}

EMOJI=🦁 HELLO=Moo NAME=horse bash -xe ./.ci/build-index-files.sh

grep -q "^🦁 Moo! I'm a horse.$" out/index.txt
grep -q "^cicd-tutorials / animals $" out/index.txt
