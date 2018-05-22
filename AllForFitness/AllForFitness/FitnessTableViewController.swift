//
//  FitnessTableViewController.swift
//  AllForFitness
//
//  Created by Timur Saidov on 25.03.2018.
//  Copyright © 2018 Timur Saidov. All rights reserved.
//

import UIKit

class FitnessTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    var filteredResultArray: [Training] = [] // Массив упражнений, соответствующий критериям поиска.
    
    var trains: [Training] = [
        Training(name: "Берёзка", type: "Комлексное", position: 3, image: "berezka.png", imageOne: "berezka1.png", imageTwo: "berezka2.png", imageThree: "berezka3.png", imageFour: nil, imageFive: nil, description: "Данное упражнение направлено на укрепление мышц пресса, спины, а также разработку шейного отдела.", positionOne: "Лежа на полу, с заведенными под ягодицы руками, поднимите прямые ноги под углом 90 градусов, относительно туловища.", positionTwo: "Оторвите таз от пола и поднимите его вверх, не сгибая при этом ноги. Опираться вы должны на шею и лопатки. Задержитесь в таком положении на несколько секунд. Старайтесь выполнять подъем только за счет мышц пресса.", positionThree: "Вернитесь в исходное положение, и сразу, не допуская пауз, повторите подход. Ноги всегда должны быть прямыми и поднятыми вверх перпендикулярно туловищу.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-20"),
        Training(name: "Махи ногой", type: "Комлексное", position: 3, image: "makhi.png", imageOne: "makhi1.png", imageTwo: "makhi2.png", imageThree: "makhi3.png", imageFour: nil, imageFive: nil, description: "Отличное упражнение, помогающее не только нагрузить пресс, который в момент выполнения будет в постоянном напряжении, а и немного проработать ягодичные мышцы.", positionOne: "Примите упор на локти, поставив ноги на носки, а таз подняв вверх. Спина и ноги при этом должны быть прямыми.", positionTwo: "Оторвите правую ногу от пола и поднимите ее вверх, вытягивая носок. Тело при этом должно находиться в устойчивом положении и не 'гулять' из стороны в сторону, а поднимаемая нога быть выпрямленной.", positionThree: "Опустите правую ногу и сразу же, не делаю пауз, повторите упражнение левой ногой, так же подняв ее вверх, после чего вернитесь в исходное положение.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "15-20"),
        Training(name: "Мостик", type: "Комлексное", position: 4, image: "mostik.png", imageOne: "mostik1.png", imageTwo: "mostik2.png", imageThree: "mostik3.png", imageFour: "mostik4.png", imageFive: nil, description: "Эффетивное упражнение, направленное на укрепление ягодичных мышц и задней поверхности бедра. Дополнительную нагрузку получают, при соблюдении техники выполнения, спина и пресс.", positionOne: "Займите положение лежа на спине, уперевшись в коврик обеими ступнями согнутыми в коленях ног. Старайтесь ноги придвинуть как можно ближе к тазу. Это позволит увеличить нагрузку. Руки лежат на коврике, вытянутые вдоль корпуса.", positionTwo: "На выдохе отталкиваемся пятками и силой мышц ягодиц выталкиваем таз вверх. Выполняем движение в довольно медленном темпе.", positionThree: "Стараемся вытолкнуть тазовую часть как можно выше и задерживаемся в верней точке на несколько секунд.", positionFour: "Медленно на вдохе опускаемся к полу, не напрягая при этом бедренные мускулы. Повторяем подъемы не менее 20 раз, постепенно увеличивая количество повторов и подходов.", positionFive: nil, podhody: "3-4", povtoreniya: "10-20"),
        Training(name: "Ножницы", type: "Комлексное", position: 3, image: "nozhnitsy.png", imageOne: "nozhnitsy1.png", imageTwo: "nozhnitsy2.png", imageThree: "nozhnitsy3.png", imageFour: nil, imageFive: nil, description: "Универсальное упражнение, помогающее проработать все мышцы брюшной полости, а также избавиться от лишних килограммов в этой проблемной области.", positionOne: "Лягте на спину, выпрямив ноги, а прямые руки заведите под ягодицы ладонями вниз.", positionTwo: "Поднимите прямые ноги вверх, до образования острого угла между ногами и полом (примерно на 20-30 см). Втяните живот, вытяните носки и скрестите лодыжки. Спина и таз при этом не должны отрываться от пола.", positionThree: "Начинайте делать широкие махи ногами, таким образом, чтобы одна нога всегда находилась под другой. Выполнять упражнение необходимо в быстром темпе, меня ноги местами после каждого взмаха.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "15-20"),
        Training(name: "Повороты с упором на локоть", type: "Комлексное", position: 3, image: "povoroty.png", imageOne: "povoroty1.png", imageTwo: "povoroty2.png", imageThree: "povoroty3.png", imageFour: nil, imageFive: nil, description: "Упражнение, направленное на проработку мышц бокового пресса и помогающее развить координацию движений.", positionOne: "Примите упор на локти, поставив ноги на носки, примерно на ширине плеч. Спина должна быть немного прогнутой в пояснице, таз приподнят, а ноги прямыми.", positionTwo: "Опираясь на правый локоть, перенесите на него вес тела и поднимите левую руку вверх, одновременно поворачиваясь всем телом влево. Левая нога при этом должна стоять на полу. Задержавшись на секунду в таком положении, вернитесь в исходное.", positionThree: "Повторите движение, только на этот раз поднимать необходимо праву руку, выполняя движение, зеркально противоположное предыдущему.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-15"),
        Training(name: "Приседания до параллели", type: "Базовое", position: 3, image: "prisedaniya.png", imageOne: "prisedaniya1.png", imageTwo: "prisedaniya2.png", imageThree: "prisedaniya3.png", imageFour: nil, imageFive: nil, description: "Базовое упражнение, являющееся одним из важнейших для тренировки ягодиц.", positionOne: "Станьте ровно, прогните немного спину, а ноги расставьте на ширине плеч.", positionTwo: "Не округляя спину и не отрывая пяток от пола, выполните приседание до образования между тазом и голенями прямого угла. Руки в момент выполнения прижмите к груди.", positionThree: "Задержавшись на секунду в предыдущем положении, вставайте. Спина все так же должны быть прямой и немного прогнутой в пояснице.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-12"),
        Training(name: "Прогибы назад", type: "Базовое", position: 3, image: "progiby.png", imageOne: "progiby1.png", imageTwo: "progiby2.png", imageThree: "progiby3.png", imageFour: nil, imageFive: nil, description: "Упражнение, помогающее размяться и растянуть спину, подготовив ее к дальнейшим нагрузкам.", positionOne: "Лягте на живот, вытянув руки и ноги и расслабив спину.", positionTwo: "Медленно, прогибая спину в пояснице, оторвите грудь и живот от пола, одновременно согнув руки как при отжиманиях. Ноги при этом не должны отрываться от пола. Задержитесь на 3-5 секунд в таком положении.", positionThree: "Так же медленно опуститесь на пол, приняв исходное положение и вытянув руки вперед. После короткой паузы в несколько секунд повторите подход.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "15-20"),
        Training(name: "Прыжки в сторону", type: "Комлексное", position: 3, image: "pryzhki.png", imageOne: "pryzhki1.png", imageTwo: "pryzhki2.png", imageThree: "pryzhki3.png", imageFour: nil, imageFive: nil, description: "Довольно специфическое, но оттого не менее эффективное упражнение, помогающее проработать мышцы бедер, ягодицы и квадрицепсы.", positionOne: "Стоя на полу со сведенными вместе ногами, прижмите руки к груди и немного наклонитесь вперед, как перед прыжком.", positionTwo: "Сделайте прыжок вправо, приземлившись на правую же ногу и перенеся на нее вес всего тела. Левая нога при этом должны быть в воздухе.", positionThree: "Из предыдущего положения выполните прыжок влево. Теперь весь вес должен приходиться на левую ногу, а правая должна находиться в воздухе.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-12"),
        Training(name: "Двойные скручивания", type: "Комлексное", position: 3, image: "skruchivaniya.png", imageOne: "skruchivaniya1.png", imageTwo: "skruchivaniya2.png", imageThree: "skruchivaniya3.png", imageFour: nil, imageFive: nil, description: "Сложное упражнение, направленное на проработку верхнего и нижнего отделов пресса. Выполнять его можно только предварительно размявшись.", positionOne: "Лягте на пол лицом вверх, вытянув руки и ноги. Спину и шею расслабьте.", positionTwo: "Одновременно, на выдохе, сделайте скручивание, подняв вверх руки и ноги, стараясь коснуться ими друг друга. Пальцами рук тянитесь к носкам, стараясь не сгибать при этом ноги. При этом подъем должен происходить исключительно за счет мышц пресса, вы должны чувствовать, как он напрягается.", positionThree: "Выполнив скручивание, верните в исходное положение и повторите процесс.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-15"),
        Training(name: "Выпады", type: "Базовое", position: 3, image: "vypady.png", imageOne: "vypady1.png", imageTwo: "vypady2.png", imageThree: "vypady3.png", imageFour: nil, imageFive: nil, description: "Базовое упражнение для тренировки ягодиц.", positionOne: "Встаньте прямо, немного прогнув спину, опустив плечи и поставив ноги немного уже уровня плеч.", positionTwo: "Сделав глубокий вдох, выполните шаг назад правой ногой, уперев ее на носок. Левую ногу при этом согните в колене, как при приседании. В крайней точке колено правой ноги должно находиться на расстоянии 10-15 см от пола.", positionThree: "Слегка оттолкнувшись от пола правой ногой, вставайте. Но так, чтобы основное усилие приходилось на левую ногу. После чего повторите подход, только теперь шагать необходимо левой ногой.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-12"),
        Training(name: "Планка с махами рукой", type: "Базовое", position: 4, image: "plankasmakhami.png", imageOne: "plankasmakhami1.png", imageTwo: "plankasmakhami2.png", imageThree: "plankasmakhami3.png", imageFour: "plankasmakhami4.png", imageFive: nil, description: "Это динамическое движение поможет не только накачать пресс и мышцы груди, ягодицы и бедра, но и проработает, растянет позвоночник.", positionOne: "Принимаем исходное положение классической планки, но с расположением ног шире плеч. Для чего упираемся в прямые руки (ступни расставлены широко, пятки смотрят вверх).", positionTwo: "Работать будем сначала правой рукой. Выводим ее вперед параллельно полу.", positionThree: "Без остановки делаем мах этой же конечностью, заводя ее резко под корпусом между разведенных ног.", positionFour: "В это же время ягодицы приподнимаем вверх, чтобы туловище и ноги образовали прямой угол. Не останавливаемся и продолжаем махи рук вперед-назад, одновременно приподнимая и опуская таз.", positionFive: nil, podhody: "3-4", povtoreniya: "10-12"),
        Training(name: "Планка с приведением колена", type: "Базовое", position: 5, image: "plankasprivedeniem.png", imageOne: "plankasprivedeniem1.png", imageTwo: "plankasprivedeniem2.png", imageThree: "plankasprivedeniem3.png", imageFour: "plankasprivedeniem4.png", imageFive: "plankasprivedeniem5.png", description: "Данное упражнение усилит напряжение пресс и поможет раскрыть тазобедренные суставы.", positionOne: "Становимся в упор на носки и вытянутые руки. Это позиция классической верхней планки. При этом ладошки расположены под плечами, а ноги сведены вместе.", positionTwo: "На выдохе сгибаем левую ногу в колене и через сторону приводим колено к одноименному локтю. Останавливаемся в этой позе на 3 – 5 счетов.", positionThree: "Возвращаем ногу в исходное положение.", positionFour: "Повторяем приведение колена дважды.", positionFive: "Теперь притягиваем колено той же ноги к противоположному локтю. Для этого нужно согнутую ногу подвести под корпусом. Также после 5 счетов выпрямляем ногу и ставим в упор на носок. Таким способом повторяем притягивание колена дважды.", podhody: "3-4", povtoreniya: "10-20"),
        Training(name: "Отжимания с колен", type: "Базовое", position: 3, image: "otzhimaniya.png", imageOne: "otzhimaniya1.png", imageTwo: "otzhimaniya2.png", imageThree: "otzhimaniya3.png", imageFour: nil, imageFive: nil, description: "Базовое упражнение на все группы мышц.", positionOne: "Примите упор лежа на прямые руки и колени. Напрягите и выпрямите спину. Руки должны быть расставлены шире уровня плеч, а колени сведены вместе.", positionTwo: "Не спеша, на выдохе согните руки в локтях, стараясь грудью коснуться пола. Не округляйте при этом спину и не опускайте голову.", positionThree: "Так же медленно выпрямите руки, вернувшись в исходное положение, после чего повторите подход.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-12"),
        Training(name: "Супермен", type: "Базовое", position: 3, image: "superman.png", imageOne: "superman1.png", imageTwo: "superman2.png", imageThree: "superman3.png", imageFour: nil, imageFive: nil, description: "Упражнение, направленное на проработку мышц спины и ног, также помогающее развить координацию.", positionOne: "Лягте на пол, лицом вниз. Спину прогните, а руки и ноги распрямите и вытяните.", positionTwo: "Медленно оторвите правую ногу от пола и поднимите ее вверх на 20-30 см, одновременно с этим поднимите и левую руку, прогибая при этом спину. Задержитесь на несколько секунд в этом положении.", positionThree: "Медленно, без удара об пол вернитесь в исходное положение, после чего повторите подход, только в этот раз поднимать необходимо левую ногу и правую руку.", positionFour: nil, positionFive: nil, podhody: "3-4", povtoreniya: "10-15"),
        Training(name: "Дятел", type: "Базовое", position: 4, image: "dyatel.png", imageOne: "dyatel1.png", imageTwo: "dyatel2.png", imageThree: "dyatel3.png", imageFour: "dyatel4.png", imageFive: nil, description: "Довольно сложно упражнение, во время которого мышцы спины, ног и ягодицы будут находиться в постоянном напряжении.", positionOne: "Расставьте ноги, вынесите правую вперед, а левую напротив, отставьте немного назад. Напрягите спину и ягодицы, а руки опустите вниз.", positionTwo: "Не меняя положения ног и не расслабляя спину, поднимите руки вверх.", positionThree: "Перенеся вес на правую ногу, наклонитесь немного вперед, только не округляйте при этом спину. Ваше туловище должно образовать прямую линию с левой ного", positionFour: "Не поднимая туловище, опустите руки вниз, вытянув их вдоль корпуса. После чего вернитесь в исходное положение. После выполнения нужного количества подходов, поменяйте местами ноги и повторите упражнение.", positionFive: nil, podhody: "3-4", povtoreniya: "12-15")]
    
    override func viewWillAppear(_ animated: Bool) {
//        navigationController?.hidesBarsOnSwipe = true // Прячем Navigation Bar при проматывании вниз.
//        UIApplication.shared.statusBarStyle = .default 
//        setNeedsStatusBarAppearanceUpdate()
    }
    
    func filterContentFor(searchText text: String) {
        filteredResultArray = trains.filter { (trains) -> Bool in
            return (trains.name.lowercased().contains(text.lowercased())) // В filteredResultArray помещаются только те элементы, имя которых содержит тот же самый текст, что и в поисковом запросе. lowercased() - метод, который принудительно превращает все буквы имени ресторана в строчные, так же, как и весь запрос.
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Новый NavBar.
        navigationController?.navigationBar.prefersLargeTitles = true
        let attributes = [
            NSAttributedStringKey.foregroundColor: UIColor.blue]
        navigationController?.navigationBar.largeTitleTextAttributes = attributes
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false // Убираем затемнение tableView.
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = #colorLiteral(red: 0.9030755635, green: 0.9030755635, blue: 0.9030755635, alpha: 1) // Цвет панели SearchBar.
        searchController.searchBar.tintColor = .blue // Цвет шрифта.
        definesPresentationContext = true // Поисковая строка (searchController) не переходит на DetailViewController.
        
//        tableView.estimatedRowHeight = 85
//        tableView.rowHeight = UITableViewAutomaticDimension
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil) // Убрать текст "Все упражнения" из кнопки назад в Navigation Bar.
    }
    
    // Метод, позволяющий при загрузке главного экрана (таблицы), вызвать и отобразить PageViewController.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let wasWatched = userDefaults.bool(forKey: "wasWatched")
        guard !wasWatched else { return } // Если обе страницы просмотрены, то ключ true трансформируется в false, и мы выходим из цикла через else { return }. Отображается таблица из метода viewDidLoad.
        if let pageViewController = storyboard?.instantiateViewController(withIdentifier: "pageViewController") as? PageViewController {
            present(pageViewController, animated: true, completion: nil) // Если pageViewController с данным идентификатором найден, он отображается. И далее исполнение переходит в файл РageViewController.swift, где как раз записан класс этого контроллера.
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Возвращаем точное количество ячеек, равное кол-ву элементов либо в массив trains, либо в массиве filteredResultArray.
        if searchController.isActive && searchController.searchBar.text != "" {
            return filteredResultArray.count
        }
        return trains.count
    }
    
    func trainsToDisplayAt(indexPath: IndexPath) -> Training {
        let exercise: Training // Создаем константу, в которую потом поместим значения либо с одного массива, либо с другого.
        if searchController.isActive && searchController.searchBar.text != "" {
            exercise = filteredResultArray[indexPath.row]
        } else {
            exercise = trains[indexPath.row]
        }
        return exercise
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FitnessTableViewCell
        let exercise = trainsToDisplayAt(indexPath: indexPath)
        
        cell.fitnessImageView.image = UIImage(named: exercise.image)
        cell.fitnessImageView.layer.cornerRadius = 32.5
        cell.fitnessImageView.clipsToBounds = true
        cell.nameLabel.text = exercise.name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) // Исчезание выделения выбранной ячейки.
    }
    
    // Custom Row Actions для выбранной ячейки (смахивание влево - поделиться и удалить).
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let share = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Поделиться") { (action: UITableViewRowAction, indexPath) -> Void in
            let defaultText = "Я сейчас выполняю" + self.trains[indexPath.row].name
            if let image = UIImage(named: self.trains[indexPath.row].image) {
                let activityController = UIActivityViewController(activityItems: [defaultText, image], applicationActivities: nil)
                self.present(activityController, animated: true, completion: nil)
            }
        }
        //        let delete = UITableViewRowAction(style: UITableViewRowActionStyle.default, title: "Удалить") { (action: UITableViewRowAction, indexPath) -> Void in
        //            self.trains.remove(at: indexPath.row)
        //            tableView.deleteRows(at: [indexPath], with: .fade)
        //        }
        share.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        //        delete.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        return [share]
    }
    
    // Подготовка к переходу на ViewController. При нажатии на ячейку, вызывается данный метод.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? ExerciseDetailViewController else { return } // Конечный контролер, который кастится к EateryDetailViewController, чтобы получить его св-ва.
                dvc.train = trainsToDisplayAt(indexPath: indexPath)
                dvc.id = Double(indexPath.row)
            }
        }
    }
}

// Подписываемся под протокол UISearchResultsUpdating для поисковой панели в tableView.
extension FitnessTableViewController: UISearchResultsUpdating {
    // Этот метод вызывается тогда, когда что-то изменяется в поисковом запросе. Тогда сразу обновляется tableView.
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
        tableView.reloadData() // Перезагружаем таблицу.
    }
}

extension FitnessTableViewController: UISearchBarDelegate {
    // Метод, означающий то, когда мы щелкаем на поисковую строку.
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if searchBar.text == "" {
            navigationController?.hidesBarsOnSwipe = false // navigationController прячется. То есть остается только searchController.
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.hidesBarsOnSwipe = true // Когда мы ушли с этого окна, мы обратно активируем navigationController
    }
}




