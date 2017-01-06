public with sharing class TaskListUpdateController {
    public List<Task> taskList {get; set;}

    public TaskListUpdateController(ApexPages.StandardController controller) {
        //taskList = (List<Task>) controller.getSelected();
    }
}