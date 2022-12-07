abort('No input file...') if ARGV[0].nil?

# A tree seems like the most logical structure.
# Node can have children
# Node type can be File or Dir
# Size = bytes or length
# This way, we can maybe sum the node values easily.
# Once we have the representations, then we can parse the input and build the tree.

class AFileSystem
  attr_reader :root

  def initialize(input)
    @root = build_tree(input)
  end

  def pretty_print(node = @root, prefix = '')
    info = node.type == 'folder' ? "(dir, size=#{size_of(node)})" : "(file, size=#{node.size})"
    puts "#{prefix}| #{node.name} #{info}"
    if node.children
      node.children.each do |child|
        pretty_print(child, "#{prefix}--")
      end
    end
  end

  def size_of(node = @root, sum = 0)
    return 0 if node.size.nil?
    return node.size if node.type == 'file'

    node.children.each do |child|
      sum += size_of(child, child.type == 'folder' ? 0 : sum)
    end
    sum
  end

  def part1
    part1_traverse.sum
  end

  def part1_traverse(node = @root, total = [])
    current_node_size = node.type == 'folder' ? size_of(node) : 0
    total << current_node_size if current_node_size <= 100_000

    node.children.each do |child|
      part1_traverse(child, total)
    end

    total
  end

  def part2
    free_space = 70_000_000 - size_of(@root)
    update_size = 30_000_000
    required_space = free_space - update_size
    eligible_dirs = part2_traverse(required_space)
    eligible_dirs.filter { |dir_size| dir_size + free_space >= update_size }.min
  end

  def part2_traverse(required_space, node = @root, eligible = [])
    current_node_size = node.type == 'folder' ? size_of(node) : nil
    eligible << current_node_size if current_node_size && current_node_size >= required_space 

    node.children.each do |child|
      part2_traverse(required_space, child, eligible)
    end

    eligible
  end

  private

  def process_nodes(lines, parent)
    lines.each do |line|
      node = line.start_with?('dir') ? AFolder.new(line.split.last) : AFile.new(line.split.last, line.split.first.to_i)
      node.parent = parent
      parent.children << node
    end
    parent
  end

  def build_tree(input)
    current_dir = nil
    top_level = nil
    children_to_process = []
    input.map do |line|
      if line.start_with?('$')
        next if line.split.length == 2

        process_nodes(children_to_process, current_dir) if children_to_process.length.positive?
        if current_dir && current_dir.children.any? {|child| child.name == line.split.last }
          current_dir = current_dir.children.find { |child| child.name == line.split.last }
        elsif line.split.last == '..'
          current_dir = current_dir.parent
        else
          current_dir = AFolder.new(line.split.last)
        end
        children_to_process = []

        top_level = current_dir if current_dir.name == '/'
      else
        children_to_process << line
      end
    end
    process_nodes(children_to_process, current_dir) if children_to_process.length.positive?
    children_to_process = []
    top_level
  end
end

##
# Node class
class Node
  attr_accessor :parent, :children
  attr_reader :name, :type

  def initialize(name, type)
    @name = name
    @type = type
    @children = []
    @parent = nil
  end

  def size
    raise NotImplementedError, "#{self.class} has not implemented method #{__method__}"
  end
end

class AFile < Node
  attr_reader :size

  def initialize(name, size)
    super(name, 'file')
    @size = size
  end
end

class AFolder < Node
  def initialize(name)
    super(name, 'folder')
  end

  def size
    0
  end
end

commands = File.open(ARGV[0]).readlines(chomp: true)
fs = AFileSystem.new(commands)

fs.pretty_print

puts "Sum total of directories under 100,000 bytes: #{fs.part1}"
puts "Smallest directory size to delete that will allow update to fit: #{fs.part2}"
