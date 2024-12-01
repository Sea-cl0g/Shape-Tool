class Canvas extends Block{
    Canvas () {
        super(16, 16);
    }
    
    void drawCanvas(){
        println("a");
    }

    void drawItems(){
        println("items");
    }

    //====================================================================================================

    void add_rectangle(){
        println("rect_added");
    }

    void add_ellipse(){
        println("ellipse_added");
    }
}