def remote_ruby(code_multiline)
  run <<-CMD
    cd #{current_release} && ruby -e '#{code_multiline.gsub(/\n/, ';')}'
  CMD
end

def get_arg(cmd_name)
  ARGV.values_at(Range.new(ARGV.index(cmd_name)+1, -1))
end

def lns(source, target)
  run "rm -f #{target} && ln -s #{source} #{target}"
end

