cd ..
read -p "Tag (volitelny):" tag

if [[ "$tag" != "" ]] ; then
    git tag "$tag"
    git push origin "$tag"
fi
