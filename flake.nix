{
  description = "tetrs";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      rust-overlay,
    }:
    let
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        overlays = [ (import rust-overlay) ];
      };

      rust = pkgs.rust-bin.stable."1.80.0".default.override {
        extensions = [ "rust-src" ];
        targets = [ ];
      };
      rustPlatform = pkgs.makeRustPlatform {
        rustc = rust;
        cargo = rust;
      };

      confetty = rustPlatform.buildRustPackage {
        version = "0.1.0";
        pname = "confetty_rs";
        src = pkgs.fetchFromGitHub {
          owner = "Handfish";
          repo = "confetty_rs";
          rev = "2012f53672b08d96c1f14aab90e19011bb78a888";
          hash = "sha256-3UGKD/niuqaZ1CxWKAF4RH6v9uJ+ckweIclwobV2EN8=";
        };

        cargoHash = "sha256-zd9iJxYtBUo10S3yej4Xm8mS7mbiym9G953vF1nVMEM=";

      };
    in
    {
      packages.x86_64-linux.default = confetty;
    };
}
