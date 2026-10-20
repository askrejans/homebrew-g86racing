class IoToNet < Formula
  desc "Transparent bridge from serial, CAN, I2C, GPIO and BLE to TCP, TLS and WebSocket"
  homepage "https://github.com/askrejans/io-to-net"
  version "0.2.0"
  license "GPL-3.0-only"

  # Tarballs are published to g86racing.com by
  # infra/deploy/scripts/publish-packages.sh; scripts/bump-formula.sh refreshes
  # the version and checksums below.
  on_macos do
    on_arm do
      url "https://g86racing.com/packages/mac/io-to-net_#{version}_macos-arm64.tar.gz"
      sha256 "4b922d900c50d95d2c4c95fdd1f0faa78e0bc4dbb3b7df44c2f6707b277f0285"
    end
    on_intel do
      url "https://g86racing.com/packages/mac/io-to-net_#{version}_macos-x86_64.tar.gz"
      sha256 "ef5328ad0f36e27503aa56c58320a4a4a9f9724af8ad54360ad858e1124f12ef"
    end
  end

  def install
    bin.install "io-to-net"
    (etc/"io-to-net").mkpath
    etc.install "config.toml.example" => "io-to-net/config.toml.example"
    doc.install "AI_TRAINING_RESTRICTION.md"
  end

  def caveats
    <<~EOS
      List serial ports (with USB selectors), then copy and edit the config:
        io-to-net --scan
        cp #{etc}/io-to-net/config.toml.example #{etc}/io-to-net/config.toml
        $EDITOR #{etc}/io-to-net/config.toml
        io-to-net --check-config --config #{etc}/io-to-net/config.toml

      Run interactively (terminal dashboard):
        io-to-net --config #{etc}/io-to-net/config.toml
      or as a service; the web dashboard is on http://127.0.0.1:9106/
        brew services start askrejans/g86racing/io-to-net
    EOS
  end

  service do
    run [opt_bin/"io-to-net", "--headless",
         "--config", "#{etc}/io-to-net/config.toml"]
    keep_alive true
    log_path   var/"log/io-to-net.log"
    error_log_path var/"log/io-to-net.log"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/io-to-net --version")
    (testpath/"config.toml").write <<~TOML
      [[bridges]]
      name = "t"
      [bridges.source]
      type = "tcp_client"
      address = "127.0.0.1:1"
      [bridges.transport]
      type = "tcp"
      listen = "127.0.0.1:0"
    TOML
    assert_match "OK, 1 bridge", shell_output("#{bin}/io-to-net --check-config --config #{testpath}/config.toml")
  end
end
