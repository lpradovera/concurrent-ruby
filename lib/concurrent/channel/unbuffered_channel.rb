require 'concurrent/channel/waitable_list'
require 'concurrent/concern/deprecation'

module Concurrent
  module Channel

    # @api Channel
    # @!macro edge_warning
    class UnbufferedChannel
      include Concurrent::Concern::Deprecation

      def initialize
        deprecated 'Use Concurrent::Edge::Channel instead'
        @probe_set = WaitableList.new
      end

      def probe_set_size
        @probe_set.size
      end

      def push(value)
        until @probe_set.take.try_set([value, self])
        end
      end

      def pop
        probe = Channel::Probe.new
        select(probe)
        probe.value
      end

      def select(probe)
        @probe_set.put(probe)
      end

      def remove_probe(probe)
        @probe_set.delete(probe)
      end

    end
  end
end
