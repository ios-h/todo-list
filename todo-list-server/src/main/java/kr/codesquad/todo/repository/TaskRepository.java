package kr.codesquad.todo.repository;

import kr.codesquad.todo.domain.Task;
import org.springframework.http.ResponseEntity;

import java.util.List;

public interface TaskRepository {
    Task add(Task task);

    List<Task> getAll();

    Task changeStatus(long idx, int status);

    int delete(int idx);

    int writeAddLog(Task task);
}
