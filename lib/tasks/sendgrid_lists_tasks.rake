require "sendgrid_lists"

task :load do
  begin
    Rake::Task["environment"].invoke
  rescue
  end
end
