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
    *   If the concrete layout does extend ActiveView (or is dynamic), 
    *   ActionController will apply current attribute values to the layout
    *   as well as the current view.
    *   
    *   This allows us to update global navigation presentation as needed.
    *   
    *   Layouts will have their width and height set to whatever dimensions
    *   are available in their parent at the time of creation. 
    *   
    *   If your parent application is a Flex application container, you can set
    *   parcentWidth and percentHeight attributes in your layout to have 
    *   it expand and collapse with the stage. 
    *   
    *   If you are not working with Flex, your layout will need to listeners
    *   to the stage resize event after Event.ADDED_TO_STAGE handled.
    *   
    **/
    public class ActiveView extends View {
        
        public function get contentContainer():DisplayObjectContainer {
            return this;
        }
    }
}
