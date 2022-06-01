(define-module (ferenginar-system)
  #:use-module (base-system)
  #:use-module (gnu)
  #:use-module (gnu packages xorg))

(use-service-modules linux)

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

;  (packages 
;   (append (list xbacklight)))

;  (services
;    (append (list (service wpa-supplicant-service-type)) %xorg-slim-services))

  (services (modify-services %xorg-slim-services
    (delete zram-device-service-type)))


  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "40be9e16-d03b-47d4-a897-1e57d76ad883"
                     'btrfs))
             (type "btrfs")
             (options "compress=zstd:1"))
           (file-system
             (mount-point "/boot/efi")
             (device (uuid "7FD1-81C6" 'fat32))
             (type "vfat"))
           %base-file-systems)))
