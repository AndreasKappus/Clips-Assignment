(defrule hydrological-check(not(hydro-check)) =>
(printout t "What are the readings for the hydrological survey(press 1 for no issues, press 2 for flooding/run-off, press 3 for erosion)" crlf (assert(hydro-check(read)))))

(defrule flooding-error(hydro-check 2) => (printout t "Unsuitable build site! Flooding or run-off in the area!" crlf (reset)(run)))

(defrule erosion-error(hydro-check 3) => (printout t "Unsuitable build site! Land erosion likely" crlf (reset)(run)))

(defrule energy-production-check(hydro-check 1) =>
(printout t "What is the projected energy production? (press 1 for high, 2 for medium, 3 for low)" crlf (assert(energy-check(read)))))

(defrule low-energy (energy-check 3) => (printout t "Unsuitable build site! not profitable to build!" crlf (reset)(run)))

(defrule wildlife-score-check (or(energy-check 2)(energy-check 1))=>
(printout t "Enter amount of endangered bird species: ") (bind ?en (read-number))
(printout t "Enter amount of scarce bird species: ") (bind ?sn (read-number))
(printout t "Enter amount of common bird species: ") (bind ?cn (read-number))

(bind ?en-total (* ?en 3))
(bind ?sn-total (* ?sn 2))
(bind ?cn-total (* ?cn 1))

(bind ?total (+ ?en-total ?sn-total ?cn-total))
(printout t "Total amount of bird species: " ?total crlf)
(assert (x ?total))
)

(defrule high-wildlife(x ?x)(test (>= ?x 20)) => (printout t "Build site rejected! too much impact on wildlife!" crlf (reset)(run)))

(defrule low-wildlife-vis-impact (x ?x)(test(<= ?x 10)) =>
(printout t "What is the visual impact on the area? (press 1 for close, press 2 for fairly distant, press 3 for very distant)" crlf (assert(visual-check(read)))))

(defrule low-wildlife-sound-impact(visual-check 1) =>
(printout t "What is the sound impact on the population? (press 1 for quiet, press 2 for loud)" crlf (assert(sound-impact-check(read)))))

(defrule low-wildlife-loud-impact (sound-impact-check 2) => (printout t "Unsuitable build site! negative impact on population!" crlf (reset)(run)))

(defrule low-wildlife-geo-survey (or(visual-check 2)(sound-impact-check 1)) =>
(printout t "What are the geological survey readings?(press 1 for stable/partly stable, press 2 for unstable)" crlf (assert(geological-check(read)))))
(defrule Stable/partly-ground (geological-check 1) => (printout t "Build site Accepted as Second best option! Stabilise ground if survey says partly stable..." crlf (reset)(run)))

(defrule geo-survey-possible-best(visual-check 3) =>
(printout t "What are the geological survey readings?(press 1 for stable, press 2 for partly stable, press 3 for unstable)" crlf (assert(geo-ground-check(read)))))
(defrule rejected-geo (geo-ground-check 3) => (printout t "Build site Unsuitable! unstable ground!" crlf (reset)(run)))

(defrule geo-second-Best(geo-ground-check 2) => (printout t "Accepted as Second Best build site! Stabilise the land if needed... " crlf (reset)(run)))

(defrule medium-energy-geo-check-output (and(geo-ground-check 1)(energy-check 2)) => (printout t "Accepted as second best build site due to medium energy production!" crlf (reset)(run)))
(defrule geo-best (and(geo-ground-check 1)(energy-check 1)) => (printout t "Accepted as The Best Build site! start building ASAP!" crlf (reset)(run)))

(defrule vis-impact-check (x ?x)(and(test (> ?x 10)) (test (< ?x 20))) =>
(printout t "What's the visual impact on the area? (press 1 for distant, press 2 for other cases)" crlf (assert(vis-check(read)))))

(defrule sound-impact-check(vis-check 1) =>
(printout t "What is the sound impact on the population? (press 1 for quiet, press 2 for loud)" crlf (assert(sound-check(read)))))
(defrule reject-loud-impact (sound-check 2) => (printout t "Unsuitable build site! negative impact on population!" crlf (reset)(run)))

(defrule geological-survey (or(vis-check 2)(sound-check 1)) =>
(printout t "What are the geological survey readings?(press 1 for stable/partly stable, press 2 for unstable)" crlf (assert(medium-wildlife-geological-check(read)))))
(defrule unstable-ground (medium-wildlife-geological-check 2) => (printout t "Unsuitable build site! ground is not stable! " crlf (reset)(run)))
(defrule stable-ground (medium-wildlife-geological-check 1) => (printout t "Build site Accepted as Second best option! Stabilise land and create new wildlife habitats if required..." crlf (reset)(run)))
