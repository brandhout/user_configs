(define-module (vulcan-system)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages xorg))

(use-service-modules nfs)

(operating-system
 (inherit base-operating-system)
 (host-name "vulcan")
 (keyboard-layout
     (keyboard-layout
       "us" "altgr-intl"
       #:options '("caps:swapescape")))

 (services (append (list(service nfs-service-type (nfs-configuration))) %xorg-slim-services))

  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets (list "/boot/efi"))
    (keyboard-layout keyboard-layout)))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "2125b4b0-1b52-4f32-923e-d827e8208df4"
                     'btrfs))
             (type "btrfs")
             (options "compress=zstd:1"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "2DB9-5A8F" 'fat32))
             (type "vfat"))
	   (file-system
	     (mount-point "/media/Olympus")
	     (device "172.16.0.2:volume1/Olympus" )
	     (type "nfs")
	     (mount? #f)
	     (needed-for-boot? #f)
	     (create-mount-point? #t)
             (options "rw,_netdev,noauto,user,lazytime,exec,tcp"))
           %base-file-systems)))
