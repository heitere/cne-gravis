%%
path = '../data/smurfig/one_to_one/';

nodeInfo = cell(403, 1);
nodeLabels = zeros(403,1);
nodeTypes = cell(7, 1);

typeId = 1;
contracts = readtable([path, 'contract.csv']);
s = 1;
e = s + size(contracts, 1) - 1;
nodeId = (s:e)';
contracts = [contracts, table(nodeId)];
nodeInfo(s:e) = contracts.contract;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'contracts';

typeId = 2;
courses = readtable([path, 'course.csv']);
s = e+1;
e = s + size(courses, 1) - 1;
nodeId = (s:e)';
courses = [courses, table(nodeId)];
nodeInfo(s:e) = courses.course;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'courses';

typeId = 3;
profs = readtable([path, 'prof.csv']);
s = e+1;
e = s + size(profs, 1) - 1;
nodeId = (s:e)';
profs = [profs, table(nodeId)];
nodeInfo(s:e) = profs.prof;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'profs';

typeId = 4;
programs = readtable([path, 'program.csv']);
s = e+1;
e = s + size(programs, 1) - 1;
nodeId = (s:e)';
programs = [programs, table(nodeId)];
nodeInfo(s:e) = programs.program;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'programs';

typeId = 5;
rooms = readtable([path, 'room.csv']);
s = e+1;
e = s + size(rooms, 1) - 1;
nodeId = (s:e)';
rooms = [rooms, table(nodeId)];
nodeInfo(s:e) = rooms.room;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'rooms';

typeId = 6;
students = readtable([path, 'stud.csv']);
s = e+1;
e = s + size(students, 1) - 1;
nodeId = (s:e)';
students = [students, table(nodeId)];
students.student(:) = sprintfc('stud_%d', students.id);
nodeInfo(s:e) = students.student;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'students';

typeId = 7;
tracks = readtable([path, 'track.csv']);
s = e+1;
e = s + size(tracks, 1) - 1;
nodeId = (s:e)';
tracks = [tracks, table(nodeId)];
nodeInfo(s:e) = tracks.track;
nodeLabels(s:e) = typeId;
nodeTypes{typeId} = 'tracks';

n = e;
%% 
A = zeros(n,n);

path = '../data/smurfig/many_to_many/';
course_in_room = readtable([path, 'new_course1N1.csv']);
for i = 1:size(course_in_room, 1)
    idxI = courses.nodeId(strcmp(courses.id, course_in_room.course{i}));
    idxJ = rooms.nodeId(rooms.id==course_in_room.room(i));
    A(idxI, idxJ) = 1;
end
student_in_track = readtable([path, 'new_stud1N.csv']);
for i = 1:size(student_in_track, 1)
    idxI = students.nodeId(students.id == student_in_track.student(i));
    idxJ = tracks.nodeId(tracks.id==student_in_track.track(i));
    A(idxI, idxJ) = 1;
end

student_in_program = readtable([path, 'new_stud1N2.csv']);
for i = 1:size(student_in_program, 1)
    idxI = students.nodeId(students.id == student_in_program.student(i));
    idxJ = programs.nodeId(programs.id==student_in_program.program(i));
    A(idxI, idxJ) = 1;
end
student_in_contract = readtable([path, 'new_stud1N3.csv']);
for i = 1:size(student_in_contract, 1)
    idxI = students.nodeId(students.id == student_in_contract.student(i));
    idxJ = contracts.nodeId(contracts.id==student_in_contract.contract(i));
    A(idxI, idxJ) = 1;
end
student_takes_course = readtable([path, 'new_takes.csv']);
for i = 1:size(student_takes_course, 1)
    idxI = students.nodeId(students.id == student_takes_course.student(i));
    idxJ = courses.nodeId(strcmp(courses.id, student_takes_course.course(i)));
    A(idxI, idxJ) = 1;
end
prof_teachs_course = readtable([path, 'new_teaches.csv']);
for i = 1:size(prof_teachs_course, 1)
    idxI = profs.nodeId(profs.id == prof_teachs_course.prof(i));
    idxJ = courses.nodeId(strcmp(courses.id, prof_teachs_course.course(i)));
    A(idxI, idxJ) = 1;
end
A = A | A';
% figure, imagesc(A);
