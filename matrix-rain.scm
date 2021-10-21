(import (chicken condition)
        miscmacros
        (prefix sdl2 "sdl2:")
        (prefix sdl2-ttf "ttf:"))

(define screen-width 1280)
(define screen-height 720)

(define target-fps 165)
(define delay-time (round (/ 1000 target-fps)))

(sdl2:set-main-ready!)
(sdl2:init! '(events video))
(ttf:init!)

(define window (sdl2:create-window! "matrix-rain"
                                    'centered 'centered
                                    screen-width screen-height))
(define renderer (sdl2:create-renderer! window))

(define bg-color (sdl2:make-color 0 0 0))
(define fg-color (sdl2:make-color 0 255 0))

(define font (ttf:open-font "DMMono-Regular.ttf" 16))

(on-exit sdl2:quit!)
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))

(define bg-surf
  (let ((rect (sdl2:make-rect 0 0 screen-width screen-height))
        (surf (sdl2:make-surface screen-width screen-height 'rgb888)))
    (sdl2:fill-rect! surf rect bg-color)
    surf))
(define (clear!)
  (sdl2:blit-surface! bg-surf #f (sdl2:window-surface window) #f))

(define (draw-text! text)
  (define-values (w h) (ttf:size-utf8 font text))
  (define text-surf (ttf:render-utf8-shaded font text
                                            fg-color bg-color))
  (sdl2:blit-surface! text-surf #f (sdl2:window-surface window) #f))

(define (main)
  (define done #f)
  (define event #f)
  (while (not done)
    (sdl2:pump-events!)
    (while (sdl2:has-events?)
      (set! event (sdl2:poll-event! event))
      (case (sdl2:event-type event)
        ((quit) (set! done #t))))
    (clear!)
    (draw-text! "Hello, World.")
    (sdl2:update-window-surface! window)
    (sdl2:delay! delay-time)))

(main)
