
#ifndef _THREADS_H
#define _THREADS_H

#include <stdint.h>

// DATA STRUCTURES

typedef struct mtx_s
{

   uint8_t thrd_owner;
   uint8_t mutex_type;
   uint8_t lock_count;
   
   uint8_t spinlock;
   void   *q;             // p_forward_list *

} mtx_t;

typedef uint16_t       once_flag;
#define ONCE_FLAG_INIT 0x00fe

#if __SDCC | __SDCC_IX | __SDCC_IY

// SDCC

// mutex

extern void   call_once(once_flag *flag, void (*func)(void));
extern void   mtx_destroy(mtx_t *m);
extern int    mtx_init(mtx_t *m, int type);
extern int    mtx_lock(mtx_t *m);
extern int    mtx_timedlock(mtx_t *m, struct timespec *ts);
extern int    mtx_trylock(mtx_t *m);
extern int    mtx_unlock(mtx_t *m);
extern void   spinlock_acquire(char *spinlock);
extern void   spinlock_release(char *spinlock);
extern int    spinlock_tryacquire(char *spinlock);

#else

// SCCZ80

// mutex

extern void   __LIB__               call_once(once_flag *flag, void *func);
extern void   __LIB__ __FASTCALL__  mtx_destroy(mtx_t *m);
extern int    __LIB__               mtx_init(mtx_t *m, int type);
extern int    __LIB__ __FASTCALL__  mtx_lock(mtx_t *m);
extern int    __LIB__               mtx_timedlock(mtx_t *m, struct timespec *ts);
extern int    __LIB__ __FASTCALL__  mtx_trylock(mtx_t *m);
extern int    __LIB__ __FASTCALL__  mtx_unlock(mtx_t *m);
extern void   __LIB__ __FASTCALL__  spinlock_acquire(char *spinlock);
extern void   __LIB__ __FASTCALL__  spinlock_release(char *spinlock);
extern int    __LIB__ __FASTCALL__  spinlock_tryacquire(char *spinlock);

// SCCZ80 CALLEE LINKAGE

// mutex

extern void   __LIB__ __CALLEE__    call_once_callee(once_flag *flag, void *func);
extern int    __LIB__ __CALLEE__    mtx_init_callee(mtx_t *m, int type);
extern int    __LIB__ __CALLEE__    mtx_timedlock_callee(mtx_t *m, struct timespec *ts);

// SCCZ80 MAKE CALLEE LINKAGE THE DEFAULT

// mutex

#define call_once(a,b)              call_once_callee(a,b)
#define mtx_init(a,b)               mtx_init_callee(a,b)
#define mtx_timedlock(a,b)          mtx_timedlock_callee(a,b)

#endif

#endif
