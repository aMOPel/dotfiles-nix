rec {
  username = "momo";
  homeDirectory = "/home/${username}";
  nixos = {
    luksDiskPath = "/dev/disk/by-uuid/202612e0-7bb7-481d-bb52-e874b07b42ce";
    hostname = "homelab-one";
    system = "x86_64-linux";
    knownHosts = {
      # "<host>".publicKey =
      #   "ssh-rsa <key>";
    };
    authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEPGNQt7xa+8hYGMlGK8lLrhbYaYAin00V0XyWrcq/ImQF7uqWBXf1I09WxCsoFThIUVybgyP0bOXZA9p09c6WrlKEBRr606bMH8KxwXUt5h4lpEpXDP31Qz25zVxGDCC/sfAwP/qmGDjKF2/OeNxnydh/kuq+xTCGaTJ/B5zI3gj/up85HVHYszYQZpfE0UcPjqNwHugQTcNIbs28Gw+NS3BcfrLareIcKboKE3p1q6r5210PxqCiTvksZIIeFaFqhZesMD5Rcln0NWXSYWW6zAcZEKRUFAwNQtCJdOFy60YNBLvju+nLiBDTkYRkfzUkRtNmtmCBL+alxCNqV/K+Fstlbs9lbd8iw2McbpCCSqyU5gIFG+rTTxZZwW6e3nQgNrzfAuwtLVR2A2PMMCURYMzlk6Rhl3fkTNucvntB2+OLNvJJAj6RfmXqhpfJFQgE6RpFpZgYGkISv0VGn+Lya0GYTcdvC+Vajj1mP0JeGnv+TTnBZVrHBGGqth4YZlDw9nvsEuQCw0nTjFwq8++sp63gr/qi/Gav7mlmIzO3KEin3WcySXVOfaEcJaE7phtIuRpY4Ffoam2Rm7VtInj8vOmow6NtRv0+mW04d4NYWe8jkHCsazxYnrjAuNQLK/AL7dYzLS1OSMJqkNlIqcF/VTkFo7hre9aonJRZa929Pw== cardno:32_443_537"
    ];
  };
}
