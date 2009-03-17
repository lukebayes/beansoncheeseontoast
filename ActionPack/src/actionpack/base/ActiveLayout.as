package actionpack.base {
    
    import flash.display.DisplayObjectContainer;
    
    /**
    *   Concrete layouts simply need to implement an accessor
    *   called 'contentContainer'.
    *   
    *   The DisplayObjectContainer that is returned from this accessor,
    *   is where currently-displayed views will be added.
    *   
    *   There is no need to extend this class or implement a particular
    *   interface, the contentContainer method is all that is required.
    *   
    *   If the concrete layout does extend ActiveLayout (or is dynamic), 
    *   ActionController will apply current attribute values to the layout
    *   as well as the current view.
    *   
    *   This allows us to update global navigation presentation as needed.
    *   
    *   Layouts will have their width and height set to whatever dimensions
    *   are available in their parent. If the outer parent of a layout is 
    *   the stage, they can expect to grow and shrink according to a changing 
    *   stage size.
    **/
    public class ActiveLayout extends View {
        
        public function get contentContainer():DisplayObjectContainer {
            return this;
        }
    }
}
