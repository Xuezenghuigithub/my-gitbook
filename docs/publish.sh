echo "Start Publishπ"
book sm
gitbook build . docs
cp ./CNAME ./docs/
echo "Build Success!π"
git co gh-pages
git add .
git commit -m "feat: update note"
git push
echo "Publish Success!πππ"