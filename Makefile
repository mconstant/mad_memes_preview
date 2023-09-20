tools:
	bash get_tools.sh

fonts:
	mkdir -p ~/.local/share/fonts
	cp pipeline/Creepster-Regular.ttf ~/.local/share/fonts
	fc-cache -f -v

pipeline:
	cd pipeline && bundle && time bundle exec ruby pipeline.ruby

update_previews:
	git stash && git add vite_project/nfts.json && git commit -m "update previews" && git push

all: tools fonts pipeline update_previews