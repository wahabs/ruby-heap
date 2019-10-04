module BinaryHeapable
  def peek
    @store.first
  end

  def push(node)
    @store << node
    heapify_up!
    pop if @limit && size > @limit
  end

  def pop
    swap_nodes(0, @store.length - 1)
    popped = @store.pop
    heapify_down!
    popped
  end

  def parent_idx(idx)
    parent_idx = idx.even? ? (idx-2)/2 : (idx-1)/2
    parent_idx >= 0 ? parent_idx : nil
  end

  def child_indices(idx)
    left = idx*2 + 1
    right = idx*2 + 2

    [
      @store[left] ? left : nil,
      @store[right] ? right : nil,
    ]
  end

  def swap_nodes(id1, id2)
    temp = @store[id1]
    @store[id1] = @store[id2]
    @store[id2] = temp
  end

  def heapify_up!
    idx = @store.length - 1

    loop do
      parent_idx = parent_idx(idx)
      break if parent_idx.nil? || @comparator.call(@store[idx], @store[parent_idx]) <= 0
      swap_nodes(idx, parent_idx)
      idx = parent_idx
    end
  end

  def heapify_down!
    idx = 0

    loop do
      child_indices = child_indices(idx).compact

      case child_indices.length
      when 0
        break
      when 1
        target_child_idx = child_indices[0]
      when 2
        left = child_indices[0]
        right = child_indices[1]

        target_child_idx = @comparator.call(@store[left], @store[right]) >= 0 ? left : right
      end

      break if @comparator.call(@store[idx], @store[target_child_idx]) >= 0
      swap_nodes(idx, target_child_idx)
      idx = target_child_idx
    end
  end

  def to_s
    @store.to_s
  end

  def size
    @store.size
  end
end

class BinaryMaxHeap
  include BinaryHeapable
  attr_reader :store

  def initialize(limit = nil)
    @limit = limit
    @store = []
    @comparator = Proc.new { |a, b| a <=> b }
  end
end

class BinaryMinHeap
  include BinaryHeapable
  attr_reader :store

  def initialize(limit = nil)
    @limit = limit
    @store = []
    @comparator = Proc.new { |a, b| b <=> a }
  end
end
