module TaskLoop
  class Logo
    def print_logo
      logo = <<-DESC
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@          @@@@@@@@@@@@@@@@@@@@@@   @@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@    @@@@@@    @@@@@       @@@   @@   @@    @@@@@      @@@@      @@@       @@@@@@@@@
@@@@@@@@@@@    @@@@   @@   @@   @@@   @@   @   @@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@@@@@@   @@@    @@@@@@      @@@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@        @@@@@@    @@@      @@@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@   @@@   @@   @@@   @@   @   @@@    @@@@   @@   @@   @@   @@   @@   @@@@@@@@
@@@@@@@@@@@    @@@@        @@@       @@@   @@   @@      @@@      @@@@      @@@       @@@@@@@@@
@@@@@@@@@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@
@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      DESC
      puts logo.ansi.blue
  end
end