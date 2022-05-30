(define-module (vulcan-system)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages xorg))

(operating-system
 (inherit base-operating-system)
 (host-name "vulcan")
 (keyboard-layout
     (keyboard-layout
       "us" "altgr-intl"
       #:options '("caps:swapescape")))

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
           %base-file-systems)))
