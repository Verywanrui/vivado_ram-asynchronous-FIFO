# vivado_ram-asynchronous-FIFO
use vivado ram ip to generate asynchronous FIFO

signal enb is used to avoid r_data read immediately when w_data is written into the ram at the very beginning  

here is my ram settings, its a simple dual port ram, 
you can change parameters yourself, its ez
<a href="https://sm.ms/image/PJs5jxIlwEWaQMi" target="_blank"><img src="https://i.loli.net/2021/04/30/PJs5jxIlwEWaQMi.png" ></a>

here is simulation
<a href="https://sm.ms/image/gzPxrh4StqbK1HC" target="_blank"><img src="https://i.loli.net/2021/04/30/gzPxrh4StqbK1HC.png" ></a>
