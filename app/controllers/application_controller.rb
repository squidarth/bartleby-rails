class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter do
    @lines = []
    set_trace_func proc { |event, file, line, id, binding, classname|
      if $files.include?(file) && event == "line"
        logger.info "hello"
        $old_binding = $new_binding
        $new_binding = hash_from_binding(binding)
        diff = $new_binding.reject {|k, v|
          $old_binding.present? && $old_binding[k] == $new_binding[k]
        }

        old_diff = $old_binding.reject {|k,v|
          $new_binding.has_key?(k)
        }

        old_diff.each do |k,v|
          @lines << "#{File.basename(file)}:#{line}, #{k}: nil" if k.to_s.match(/@\w+/).present?
        end

        $redis.publish("values3", diff.map { |k,v| "#{File.basename(file)}:#{line}, #{k}: #{v}"}.join("\n"))
      end
    }
  end

  def hash_from_binding(bin)
    h = Hash.new
    bin.eval("local_variables").each do |i|
      v = bin.eval(i.to_s)
      v && h[i]=bin.eval(i.to_s)
    end
    bin.eval("instance_variables").each do |i|
      v = bin.eval(i.to_s)
      v && h[i]=bin.eval(i.to_s)
    end
    h
  end
end
