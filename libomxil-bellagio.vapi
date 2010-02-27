namespace Bellagio {
    [CCode (cname="tsem_t", cheader_filename="bellagio/tsemaphore.h", cprefix="tsem_")]
    public struct Semaphore {
        public int init(uint val);
        public Semaphore(uint val);
        public void up();
        public void down();
    }
}
