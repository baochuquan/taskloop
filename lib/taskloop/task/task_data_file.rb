module TaskLoop
  module TaskDataFile
    # ~/.taskloop/cache/<project-sha>.
    attr_accessor :data_proj_dir

    def logfile_path
      return File.join(@data_proj_dir, logfile_name)
    end

    def timefile_path
      return File.join(@data_proj_dir, timefile_name)
    end

    def loopfile_path
      return File.join(@data_proj_dir, loopfile_name)
    end

    def logfile_name
      return sha1 + "_log"
    end
    def timefile_name
      return sha1 + "_time"
    end
    def loopfile_name
      return sha1 + "_loop"
    end

    def write_to_logfile(content)
      file = File.open(logfile_path, "w")
      file.puts content
      file.close
    end

    def write_to_timefile(content)
      file = File.open(timefile_path, "w")
      file.puts content
      file.close
    end

    def write_to_loopfile(content)
      file = File.open(loopfile_name, "w")
      file.puts content
      file.close
    end
  end
end