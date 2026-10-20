class EcuToMqtt < Formula
  desc "Read-only ECU telemetry gateway: Speeduino, MegaSquirt, CAN to MQTT and HTTP"
  homepage "https://github.com/askrejans/ecu-to-mqtt"
  version "0.7.0"
  license "GPL-3.0-only"

  # Tarballs are published to g86racing.com by
  # infra/deploy/scripts/publish-packages.sh; scripts/bump-formula.sh refreshes
  # the version and checksums below.
  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/ecu-to-mqtt_#{version}_macos-arm64.tar.gz"
      sha256 "877bc677fda277b214a8362095f8a5d5bdd381c3da2665e236efbd382c29090f"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/ecu-to-mqtt_#{version}_macos-x86_64.tar.gz"
      sha256 "d2a31b636548bf76419e98b1ad3e94d36fa8da3d0526e280c40f166ed43609af"
    end
  end

  def install
    bin.install "ecu-to-mqtt"
    (etc/"ecu-to-mqtt").mkpath
    etc.install "settings.toml.example" => "ecu-to-mqtt/settings.toml.example"
  end

  def caveats
    <<~EOS
      Copy and edit the example config before starting:
        cp #{etc}/ecu-to-mqtt/settings.toml.example \\
           #{etc}/ecu-to-mqtt/settings.toml
        $EDITOR #{etc}/ecu-to-mqtt/settings.toml

      Replacing speeduino-to-mqtt? Stop and uninstall it first; the new build
      uses ECU_TO_MQTT_* environment variables and the /ECU/ default topic:
        brew services stop askrejans/g86racing/speeduino-to-mqtt
        brew uninstall askrejans/g86racing/speeduino-to-mqtt
    EOS
  end

  service do
    run [opt_bin/"ecu-to-mqtt", "--headless",
         "--config", "#{etc}/ecu-to-mqtt/settings.toml"]
    keep_alive true
    log_path   var/"log/ecu-to-mqtt.log"
    error_log_path var/"log/ecu-to-mqtt.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ecu-to-mqtt --version")
  end
end
