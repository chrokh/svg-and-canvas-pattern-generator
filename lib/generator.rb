#!/usr/bin/env ruby

class Shape
  attr_accessor :fill_color, :stroke_color

  def initialize
    @fill_color = Color.next
    @stroke_color = Color.next
  end
end

class Circle < Shape
  attr_accessor :x, :y, :radius

  def initialize
    super
    @x = Rand.next
    @y = Rand.next
    @radius = Rand.next_non_zero.to_f / 2
  end

  def to_xml
    "<circle cx=\"#{@x}\" cy=\"#{@y}\" r=\"#{@radius}\" fill=\"#{@fill_color}\" />"
  end
end

class Rect < Shape
  attr_accessor :x, :y, :width, :height, :rotation

  def initialize
    super
    @x = Rand.next
    @y = Rand.next
    @width = Rand.next_non_zero
    @height = Rand.next_non_zero
    @rotation = Rand.next_rotation
  end

  def to_xml
    centerX = @x + @width / 2
    centerY = @y + @height / 2
    rotation = "transform=\"rotate(#{@rotation}, #{centerX}, #{centerY})\""
    "<rect x=\"#{@x}\" y=\"#{@y}\" width=\"#{@width}\" height=\"#{@height}\" fill=\"#{@fill_color}\" #{rotation} /> "
  end
end

class Color
  def self.next
    r = next255
    g = next255
    b = next255
    "rgb(#{r},#{g},#{b})"
  end

  private

  def self.next255
    rand(0..255)
  end
end

class Rand
  def self.next(max = Boundries.steps)
    n = rand(0..max)
    n * Boundries.step_size
  end

  def self.next_non_zero(max = Boundries.steps)
    n = rand(1..max)
    n * Boundries.step_size
  end

  def self.next_rotation()
    rotation_step = 45
    steps = 360 / rotation_step
    n = rand(1..steps)
    n * rotation_step
  end
end

class Boundries
  def self.width
    500
  end

  def self.height
    self.width
  end

  def self.steps
    4
  end

  def self.step_size
    width / steps
  end
end

class Pattern
  attr_accessor :shapes

  def initialize
    @shapes = []
    3.times do
      @shapes.push Rect.new
    end
    1.times{ @shapes.push Circle.new }
  end

  def to_html
    html_opening + html_closing
  end

  def to_xml
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"no\"?>"
    xml += html_opening
    @shapes.each do |shape|
      xml += shape.to_xml
    end
    xml += html_closing
  end

  private

  def html_opening
    """
      <svg xmlns=\"http://www.w3.org/2000/svg\"
        width=\"#{Boundries.width}\"
          height=\"#{Boundries.height}\">
    """
  end

  def html_closing
    "</svg>"
  end
end


class Generator
  def initialize(number_of_examples=10)
    @patterns = []
    number_of_examples.times do
      @patterns.push Pattern.new
    end
  end

  def to_xml
    @patterns.map(&:to_xml)
  end

  def to_html
    @patterns.map(&:to_html)
  end
end


class FileWriter
  def self.write_array_to_folder(array, folder, ext)
    folder = File.join(Dir.pwd, folder)
    if(File.directory?(folder))
      array.each_with_index do |data, n|
        file = "#{n}.#{ext}"
        path = File.join(folder, file)
        File.open(path, 'w') { |file| file.write(data) }
      end
    else
      puts "Folder '#{folder}' does not exist!"
    end
  end
end

def main
  args = []
  ARGV.each do |arg|
    args.push arg
  end
  puts
  run(args)
  puts
end

def run(args)
  if args.length > 0
    case args[0]
    when "-h", "--help"
      display_help
    when "--html"
      puts Generator.new(50).to_html
    when "--xml"
      folder = args[1]
      svgs = Generator.new(50).to_xml
      FileWriter.write_array_to_folder(svgs, folder, 'svg')
      puts "\t Wrote 50 files to #{folder}/*.svg"
    end
  else
    display_help
  end
end

def display_help
  puts "\t Usage:"
  puts
  puts "\t -h (--help) \t Help"
  puts "\t --xml [folder]  Export each svg as separate xml file to path"
  puts "\t --html \t Output all svgs as inline html to STO"
end

main
