  vpc = {
    default_az    = "ap-southeast-1a"
    cidr          = "172.28.0.0/16"
    azs           = ["ap-southeast-1a", "ap-southeast-1b", "ap-southeast-1c"]
    public_cidrs  = ["172.28.0.0/20", "172.28.16.0/20", "172.28.32.0/20"]
    private_cidrs = ["172.28.128.0/20", "172.28.144.0/20", "172.28.160.0/20"]
  }

  environment = "interview"