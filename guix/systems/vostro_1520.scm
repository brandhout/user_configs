(define-module (test-system)
  #:use-module (base-system)
  #:use-module (gnu))

(operating-system
 (inherit base-operating-system)
 (host-name "vostro")
 (keyboard-layout
     (keyboard-layout
       "us" "altgr-intl"
       #:options '("caps:swapescape")))

  (swap-devices
    (list (uuid "53fd3539-95eb-4cd0-98f6-39659139d341")))
  (bootloader
   (bootloader-configuration
    (bootloader grub-bootloader)
    (target "/dev/sda")
    (keyboard-layout keyboard-layout)))

  (file-systems
    (cons* (file-system
             (mount-point "/")
             (device
               (uuid "961f760e-08a7-49e1-8f11-476b317c855e"
                     'btrfs))
             (type "btrfs"))
           %base-file-systems)))
