echo "Start Publish🏃"
book sm
git co master
gitbook build . docs
git add .
git commit -m "feat: update note"
git push
git co gh-pages
git merge master
git push
git co master
echo "Publish Success!🎉🎉🎉"