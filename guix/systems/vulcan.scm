(define-module (vulcan)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages xorg))

(use-service-modules nfs)
;(use-service-modules nix)


(operating-system
 (inherit base-operating-system)
 (host-name "vulcan")
 (keyboard-layout
     (keyboard-layout
       "us" "altgr-intl"
       #:options '("caps:swapescape")))

 (services (append (list
                    (service nfs-service-type (nfs-configuration))
                    ;(service nix-service-type)
                    ) %xorg-slim-services))

 (packages (append (list
            (specification->package "vpnc")
            (specification->package "samba")
            (specification->package "cifs-utils")
;            (specification->package "nix")
            (specification->package "nfs-utils")
            (specification->package "libnfs")) %xorg-packages))

  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets (list "/boot/efi"))
    (keyboard-layout keyboard-layout)))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "3f60784a-b36e-4503-af4b-a7385389775c"
                     'btrfs))
             (type "btrfs")
             (options "compress=zstd:1"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "376B-259B" 'fat32))
             (type "vfat"))
	   (file-system
	     (mount-point "/media/Olympus")
	     (device "172.16.0.2:volume1/Olympus" )
	     (type "nfs")
	     (mount? #t)
	     (mount-may-fail? #t)
	     (needed-for-boot? #f)
	     (create-mount-point? #t)
             (options "rw,lazytime,tcp"))
      (file-system
        (device "//172.16.0.1/Boerenbusiness")
        (title 'device)
        (options "uid=1000,gid=1000,credentials=/home/rhuijzer/.smbfile,user")
        (mount-point "/media/Boerenbusiness")
        (type "cifs")
        (mount? #f)
        (create-mount-point? #t))
           %base-file-systems)))
