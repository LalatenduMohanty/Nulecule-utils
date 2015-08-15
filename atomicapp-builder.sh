#!/bin/bash

tag_version='0.1.2'

orig_wd=`pwd`
for path in $(find `pwd` -name 'Dockerfile' | grep -v template)
do
        path=$(echo $path | sed 's/Dockerfile//g')
        cd $path

        #Build the docker image
        tag_name=$(echo $path | sed -e 's/.*\examples//g' -e 's/\///g')
        tag_name="projectatomic/$tag_name"

        echo -e "\nBuilding Atomic App $tag_name\n"
        echo "docker build -t $tag_name ."
        build_op=$(docker build -t $tag_name .)
        ID=$(echo "$build_op" | grep "Successfully built" | awk '{print $3}')

        echo -e "\ndocker tag $ID $tag_name:$tag_version\n"
        docker tag $ID $tag_name:$tag_version
done

#Changing back to the original working directory
cd $org_wd

