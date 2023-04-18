#include <stdio.h>
#include <stdlib.h>
#include <cuda.h>
#include "kernel.cu"
#include <time.h>
#include "/usr/include/python2.7/Python.h"
#include "/home/nvidia/Documents/libxlsxwriter/include/xlsxwriter.h"

long int L1_Cache_size;
// suganya checking

void init_cpu_data(int *A, int size, int stride, int mod)
{
    for (int i = 0; i < size; i = i + stride)
    {
        A[i] = (i + stride) % mod;
    }
}
int check_cache_size()
{

    int ret = system("python ./parse_csv.py  --filename L1_Cache_Size_Calculation_new.csv --threshold 1000");

    return 0;
}

void get_L1_cache_size()
{
    FILE *fp;
    fp = fopen("output.txt", "r");
    if (fp == NULL) {
        printf("Error: Could not open file.\n");
    }

    // Read an integer value from the file and store it into a variable
    int value;
    if (fscanf(fp, "%ld", &L1_Cache_size) != 1) {
        printf("Error: Could not read integer value from file.\n");
        fclose(fp);
    }
     
    
    // Print the value to the console
    printf("Read integer value from file: %ld KB\n", (L1_Cache_size * 4)/1024);

    // Close the file
    fclose(fp);
    
}

void write_to_file(FILE *fp, long long int *t_value, int *A, int size)
{

    fprintf(fp, "%d", size);
    fputs(",", fp);
    fprintf(fp, "%llu", t_value[0]);
    fputs("\n", fp);

    // static int i=0,j=0;

    // lxw_workbook  *workbook  = workbook_new("L1_Cache_Size_Calculation.xlsx");
    // lxw_worksheet *worksheet = workbook_add_worksheet(workbook, NULL);

    // // Write some data to the worksheet
    // worksheet_write_number(worksheet, i, j, size, NULL);
    // worksheet_write_number(worksheet, i, j+1, t_value[0], NULL);
    // i++;

    // // Save the workbook and free memory
    // int status = workbook_close(workbook);
}

void L1_Cache_Size_compute()
{
    int *A_h;
    long long int *tvalue_h;
    int *A_d;
    long long int *tvalue_d;
    int array_size, mod, stride = 1;

    FILE *fp;
    fp = fopen("L1_Cache_Size_Calculation_new.csv", "a+");
    fputs("Array Size, Duration Time", fp);
    fputs("\n", fp);

    for (int array_size = 2; array_size < 131072 * 2; array_size *= 2)
    {
        mod = array_size;
        A_h = (int *)malloc(sizeof(int) * array_size);
        tvalue_h = (long long int *)malloc(sizeof(long long int) * array_size);

        cudaDeviceSynchronize();
        cudaMalloc((void **)&A_d, sizeof(int) * array_size);
        cudaMalloc((void **)&tvalue_d, sizeof(long long int) * array_size);
        cudaMemcpy(tvalue_d, tvalue_h, sizeof(long long int) * array_size, cudaMemcpyHostToDevice);
        cudaDeviceSynchronize();

        init_cpu_data(A_h, array_size, stride, mod);

        cudaDeviceSynchronize();

        cudaMemcpy(A_d, A_h, sizeof(int) * array_size, cudaMemcpyHostToDevice);
        cudaDeviceSynchronize();

        P_chasing2<<<1, 1>>>(A_d, array_size, 0, tvalue_d);
        cudaDeviceSynchronize();

        cudaMemcpy(tvalue_h, tvalue_d, sizeof(long long int) * array_size, cudaMemcpyDeviceToHost);

        cudaDeviceSynchronize();

        write_to_file(fp, tvalue_h, A_h, array_size);
       

        cudaDeviceSynchronize();

        free(A_h);
        free(tvalue_h);

        cudaFree(A_d);
        cudaFree(tvalue_d);
    }
    fclose(fp);
    check_cache_size();
    get_L1_cache_size();
}

int main(int argc, char *argv[])
{

    L1_Cache_Size_compute();

    return 0;
}
