fun main() {
    val (n, m) = readln().split(' ').map { it.toInt() }
    val node = IntArray(n + 1) { it }

    fun find(b:Int): Int{
        if(node[b]==b) return b
        node[b] = find(node[b])
        return node[b]
    }

    fun union(b:Int, c:Int){
        node[find(c)] = find(b)
    }

    repeat(m) {
        val (a, b, c) = readln().split(' ').map { it.toInt() }
        when(a) {
            0 -> union(b, c)
            1 -> println(if (find(b) == find(c)) "YES" else "NO")
        }
    }

}