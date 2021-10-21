(import (chicken condition)
        miscmacros
        (prefix sdl2 "sdl2:"))

(define +screen-width+ 1280)
(define +screen-height+ 720)

(define +bg-color+ (sdl2:make-color 0 0 0))

(define +delay-time+ (round (/ 1000 144)))

(sdl2:set-main-ready!)
(sdl2:init! '(video events))

(on-exit sdl2:quit!)
(current-exception-handler
 (let ((original-handler (current-exception-handler)))
   (lambda (exception)
     (sdl2:quit!)
     (original-handler exception))))

(define win (sdl2:create-window! "matrix-rain"
                                 'centered 'centered
                                 +screen-width+ +screen-height+))
(define ren (sdl2:create-renderer! win))

(define (clear-screen!)
  (set! (sdl2:render-draw-color ren) +bg-color+)
  (sdl2:render-clear! ren))

(define (main)
  (define done #f)
  (define event #f)
  (while (not done)
    (sdl2:pump-events!)
    (while (sdl2:has-events?)
      (set! event (sdl2:poll-event! event))
      (case (sdl2:event-type event)
        ((quit) (set! done #t))
        ))
    (clear-screen!)
    (sdl2:render-present! ren)
    (sdl2:delay! +delay-time+)))

(main)
