(add-to-list 'load-path "~/.emacs.d/")

;============================================================
;                  tabbar
;============================================================
(require 'tabbar)
(tabbar-mode 1)

(global-set-key [(meta left)] 'tabbar-backward)
(global-set-key [(meta right)] 'tabbar-forward)

;; 设置tabbar外观
;; 设置默认主题: 字体, 背景和前景颜色，大小
(set-face-attribute 'tabbar-default nil
                    :family "Mono"
                    :background "gray80"
                    :foreground "gray30"
                    :height 1.0)
;; 设置左边按钮外观：外框框边大小和颜色
(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box '(:line-width 1 :color "yellow70"))
;; 设置当前tab外观：颜色，字体，外框大小和颜色
(set-face-attribute 'tabbar-selected nil
                    :inherit 'tabbar-default
                    :foreground "DarkGreen"
                    :background "LightGoldenrod"
                    :box '(:line-width 2 :color "DarkGoldenrod")
                    :overline "black"
                    :underline "black"
                    :weight 'bold)
;; 设置非当前tab外观：外框大小和颜色
(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :box '(:line-width 2 :color "#00B2BF"))

;============================================================
;                  GDB
;============================================================
;;启动gdb-many-windows时加载的钩子函数，改变many-windows的默认布局，这个钩子函数不能勾在gdb-setup-windows，因为此时assamble-buffer还没完成初始化，不能set到window  
(defadvice gdb-frame-handler-1 (after activate)  
  (if gdb-use-separate-io-buffer  
      (advice_separate_io)  
    (advice_no_separate_io)))  

;;生成没有单独IO窗口的gdb布局  
(defun advice_no_separate_io()  
  ;;默认的生成gdb-assembler-buffer的函数本身也会设计调用gdb-frame-handler-1，加入此条件发生避免无限递归调用
  (if (not (gdb-get-buffer 'gdb-assembler-buffer))
      (progn
	(shrink-window-horizontally (/ (window-width) 3))
	(other-window 1)  
	(split-window-horizontally)  
	
	(other-window 1)  
	(gdb-set-window-buffer (gdb-stack-buffer-name))  
	
	(other-window 1)  
	(split-window-horizontally)  
	
	(other-window 1)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-assembler-buffer))  
	
	(split-window-horizontally  (/ ( * (window-width) 2) 3))  
	
	(other-window 1)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-registers-buffer))  
	
	(other-window 1)  
	(toggle-current-window-dedication)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-memory-buffer))  
	(toggle-current-window-dedication)  
	
	(other-window 2)  
	)))  

;;生成有单独IO窗口的gdb布局  
(defun advice_separate_io()  
  ;;默认的生成gdb-assembler-buffer的函数本身也会设计调用gdb-frame-handler-1，加入此条件发生避免无限递归调用  
  (if (not (gdb-get-buffer 'gdb-assembler-buffer))  
      (progn  
	(split-window-horizontally)  
	(enlarge-window-horizontally ( / (window-width) 3))  
	(other-window 1)  
	
	;;此处不能使用(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-inferior-io))代替，  
	;;因为在打开gdb-use-separate-io-buffer的状态时，它还会额外调用一些函数将gdb的input，output定位到该buffer  
	(gdb-set-window-buffer (gdb-inferior-io-name))  
	
	(other-window 1)  
	(split-window-horizontally)  
	
	(other-window 1)  
	(gdb-set-window-buffer (gdb-stack-buffer-name))  
	
	(other-window 1)  
	
	(other-window 1)  
	(toggle-current-window-dedication)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-assembler-buffer))  
	(toggle-current-window-dedication)  
	
	(split-window-horizontally  (/ ( * (window-width) 2) 3))  
	
	(other-window 1)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-registers-buffer))  
	
	(other-window 1)  
	(toggle-current-window-dedication)  
	(gdb-set-window-buffer (gdb-get-buffer-create 'gdb-memory-buffer))  
	(toggle-current-window-dedication)  
	
	(other-window 2)  
	))) 