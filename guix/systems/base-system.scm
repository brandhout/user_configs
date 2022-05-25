(define-module (base-system)
 #:use-module (srfi srfi-1)
 #:use-module (gnu)
 #:use-module (gnu packages display-managers)
 #:use-module (gnu packages suckless)
 #:use-module (gnu packages xorg)
 #:use-module (gnu packages vim)
 #:use-module (nongnu packages linux)
 #:use-module (nongnu system linux-initrd)
 #:use-module (brandhout packages))

 (use-service-modules desktop xorg)
 (use-service-modules networking)
 (use-service-modules ssh)
 (use-service-modules xorg)
 (use-service-modules virtualization)
 (use-service-modules docker)
;(use-package-modules wm)
 ; voor xscreensaver
 (use-package-modules xdisorg)


 (define %user-name "rhuijzer")
 (define %full-name "Rick Huijzer")
 (define %host-name "guix")

; (define %xorg-dwm-packages
;   (list(
;	 dmenu
;          xterm
;             vim
;             brandhout-dwm
;             brandhout-st
;             rofi
;             font-fira-code
;             font-fira-mono)))

; (define %brandhout-base-packages
;   (append
;     (list nss-certs
;           qemu)
;     %base-packages))

(define %xorg-dwm-packages
  (list(specification->package "dmenu")
            (specification->package "xterm")
            (specification->package "vim")
            (specification->package "brandhout-dwm")
            (specification->package "brandhout-st")
            (specification->package "adwaita-icon-theme")
            (specification->package "gnome-themes-standard")
            (specification->package "gnome-themes-extra")
            (specification->package "xscreensaver")
            (specification->package "rofi")
            (specification->package "font-fira-code")
            (specification->package "font-fira-mono")))

(define %brandhout-base-packages
  (append
    (list (specification->package "nss-certs")
          (specification->package "qemu"))
    %base-packages))

 (define %xorg-packages (append %xorg-dwm-packages %brandhout-base-packages))
 ;(define %wayland-packages %brandhout-base-packages)
 ; okee in de override klasse (dus inherit operating system) kan je dus een package set kiezen dmv deze variabelen

; (keyboard-layout
;       "us" "altgr-intl"
;       #:options '("caps:swapescape"))

 (define %xorg-slim-services
  (cons* (service slim-service-type  
 		(slim-configuration
                		(display ":0")
                 		(vt "vt7")
 					(xorg-configuration 
					  (xorg-configuration
					    (keyboard-layout(
						keyboard-layout"us" "altgr-intl"
						#:options '("caps:swapescape")))
					    ))))
         	(service openssh-service-type)
 		(service docker-service-type)
		(screen-locker-service xscreensaver)
 		(service libvirt-service-type
           		(libvirt-configuration
          			(unix-sock-group "libvirt")
           			;(unix-sock-group "kvm")
          		 		(tls-port "16555")))
         	(modify-services %desktop-services
                 	(delete gdm-service-type))))

 (define-public base-operating-system
  (operating-system
   (kernel linux)
   (firmware (list linux-firmware))
   (initrd microcode-initrd)
   (locale "en_US.utf8")
   (timezone "Europe/Amsterdam")
   (keyboard-layout
     (keyboard-layout 
       "us" "altgr-intl"
       #:options '("caps:swapescape")))
   ;(host-name %host-name)
   (host-name "replace")
   (users (cons* (user-account
                   (name %user-name)
                   (comment %full-name)
                   (group "users")
                   ;(home-directory "/home/rhuijzer")
                   (home-directory (string-append "/home/" %user-name))
                   (supplementary-groups
                     '("wheel" "netdev" "audio" "video" "kvm" "libvirt" "docker")))
                 %base-user-accounts))

   (packages 
     ;(append (specification->package "nss-certs") %xorg-packages))
     %xorg-packages)
     ;%base-packages)

;   (services
;         (cons* (service slim-service-type  
; 		(slim-configuration
;                		(display ":0")
;                 		(vt "vt7")
; 					(xorg-configuration (xorg-configuration(keyboard-layout keyboard-layout)))))
;         	(service openssh-service-type)
; 		(service docker-service-type)
;		(service libvirt-service-type
;           		(libvirt-configuration
;          			(unix-sock-group "libvirt")
;           			;(unix-sock-group "kvm")
;          		 		(tls-port "16555")))
;         	(modify-services %desktop-services
;                 	(delete gdm-service-type))))
  (services %xorg-slim-services)



   (bootloader
     (bootloader-configuration
       (bootloader grub-bootloader)
       (target "/dev/vda")
       (keyboard-layout keyboard-layout)))
;   (swap-devices
;     (list (uuid "ebcc3ad2-0fff-439a-9bf3-75460a5cc4ab")))
   (file-systems
     (cons* (file-system
              (mount-point "/")
              (device
                (uuid "b0804161-b83b-4265-bb79-584d7eba83dc"
                      'ext4))
              (type "ext4"))
            %base-file-systems))))
