#include <stdio.h>
 
__global__ void P_chasing2(int *A, int iterations, int starting_index, long long int* t_value){  
           
           __shared__ long long int s_tvalue[1024 * 4];
           __shared__ int s_index[1024 * 4];
           int j = starting_index;
           
           long long int start_time = 0;
           long long int end_time = 0;
           long long int time_interval = 0;
           int it;


		    

           asm(".reg .u64 t1;\n\t"
           ".reg .u64 t2;\n\t");

           for (it = 0; it < iterations; it++){
                       asm("mul.wide.u32 t1, %2, %4;\n\t"          
                       "add.u64 t2, t1, %3;\n\t"            
                       "mov.u64 %0, %clock64;\n\t"                
                       "ld.global.u32 %1, [t2];\n\t"              
                       : "=l"(start_time), "=r"(j) : "r"(j), "l"(A), "r"(4));
                       
                       s_index[it] = j;
                       
                       asm volatile ("mov.u64 %0, %clock64;": "=l"(end_time));
                       
                       time_interval = end_time - start_time;
                       s_tvalue[it] = time_interval;
					   
           }
		   
		   
		     t_value[0] =  s_tvalue[it-1];
		   
		   
		   
		   
		   
}
