require 'octokit'
require 'open-uri'

class WaveshareFetcher
  SHA = 'ba202c58ec5a26bbc3dad4d3065ec597d730f373'
  DIRS = {
    GUI: %w[GUI_Paint.c GUI_Paint.h],
    'e-Paper': %w[EPD_7in5_V2.c EPD_7in5_V2.h],
    Config: %w[DEV_Config.c DEV_Config.h Debug.h RPI_sysfs_gpio.c RPI_sysfs_gpio.h dev_hardware_SPI.c dev_hardware_SPI.h],
    Fonts: %w[fonts.h],
  }
  EXT_DIRECTORY = 'ext/epaper'

  def call
    DIRS.keys.each do |dir|
      files = DIRS[dir]

      files.each do |file|
        contents = client.contents(
          'waveshare/e-Paper',
          path: "RaspberryPi_JetsonNano/c/lib/#{dir}/#{file}",
          query: { ref: SHA },
        )

        download(contents.download_url, file)
      end
    end

    update_font_includes
  end

  def clean
    DIRS.values.flatten.each do |file|
      path = file_location(file)
      FileUtils.rm(path) if File.file?(path)
    end
  end

  private

    def client
      @client ||= Octokit::Client.new
    end

    def download(url, file)
      io = ::OpenURI::open_uri(url)
      File.open(file_location(file), 'w') { |f| f.write(io.read) }
    end

    def update_font_includes
      path = file_location('./GUI_Paint.h')

      file = File.open(path)

      edited = file.readlines.map do |line|
        next "#include \"fonts.h\"\n" if line == "#include \"../Fonts/fonts.h\"\n"

        line
      end

      file.close

      File.open(path, 'w') { |f| f.write(edited.join) }
    end

    def file_location(filename)
      "#{EXT_DIRECTORY}/#{filename}"
    end
end
