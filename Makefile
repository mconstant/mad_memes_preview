tools:
	bash get_tools.sh

fonts:
	mkdir -p ~/.local/share/fonts
	cp pipeline/Creepster-Regular.ttf ~/.local/share/fonts
	fc-cache -f -v

pipeline:
	cd pipeline && bundle && time bundle exec ruby pipeline.ruby

all: tools fonts pipeline