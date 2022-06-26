echo "Start Publish🏃"
book sm
gitbook build . docs
cp ./CNAME ./docs/
echo "Build Success!🎉"
git co gh-pages
git add .
git commit -m "feat: update note"
git push
echo "Publish Success!🎉🎉🎉"