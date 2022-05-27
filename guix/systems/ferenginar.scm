(define-module (ferenginar-system)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages xorg))

(operating-system
 (inherit base-operating-system)
 (host-name "ferenginar")
 (keyboard-layout
     (keyboard-layout
       "us" "altgr-intl"
       #:options '("caps:swapescape")))

  (bootloader
   (bootloader-configuration
    (bootloader grub-efi-bootloader)
    (targets (list "/boot/efi"))
    (keyboard-layout keyboard-layout)))

  (packages 
   (append (list xbacklight)))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "b8602260-f98e-4f1d-980c-9c1b68a34908"
                     'btrfs))
             (type "btrfs"))
             (options "compress=zstd:1"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "9278-5501" 'fat32))
             (type "vfat"))
           %base-file-systems)))
