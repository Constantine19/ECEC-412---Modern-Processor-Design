proc simulate_computer {} {
    restart
    force -freeze sim:/cpu/CLK 1 0, 0 {50 ns} -r 100
    force -freeze sim:/cpu/next_pc 32'h0 0 -cancel 110
    run
    run
    run
    run
    run
    run
    run
    run
    run
    run
    run
    run
}
