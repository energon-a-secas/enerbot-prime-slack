require 'remove_bg'
require 'chunky_png'

# Gonna fix this, eventually
class ImageModify
  def initialize(path = './actions/image/')
    @path = path
  end

  def select_person(image_path)
    person_from_photo = "#{@path}slack_without_bg.png"
    RemoveBg.from_file(image_path, api_key: ENV['REMOVE_BG_KEY'], overwrite: true).save(person_from_photo)
    person_from_photo
  end

  def combine(image)
    name = "#{@path}merged.png"
    avatar = ChunkyPNG::Image.from_file("#{@path}image.png")
    badge  = ChunkyPNG::Image.from_file(image)
    avatar.compose!(badge, 555, 300)
    avatar.save(name)
    name
  end

  def download(url)
    file = "#{@path}slack.png"
    open(url) do |f|
      File.open(file, 'wb') do |file|
        file.puts f.read
      end
    end
    file
  end

  def clean
    File.delete("#{@path}merged.png")
    File.delete("#{@path}slack_without_bg.png")
    File.delete("#{@path}slack.png")
  end
end
